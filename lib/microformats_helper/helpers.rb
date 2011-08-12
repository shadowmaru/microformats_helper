# Microformats Helper is a plugin for generating content-rich tags in HTML files, following Microformats standards. For more information about Microformats, check its website (http://microformats.org).
# 
# Currently only the hCard and hreview-aggregated microformat is available.
# 
# Author:: Ricardo Shiota Yasuda (contributions by Carsten Zimmermann)
# Copyright:: Copyright (c) 2008 Ricardo Shiota Yasuda
# License:: MIT License (http://www.opensource.org/licenses/mit-license.php)
#


module MicroformatsHelper
  module Helper
    # ==Options
    # 
    # All fields are optional but the name, you are required to provide at least one of the names below.
    # 
    # ===Name
    # 
    # * +fn+ - Formal Name: should be used when no other name is provided
    # * +given+ - Given Name
    # * +family+ - Family Name
    # * +additional+ - Additional Name: goes between given and family names
    # * +prefix+ - Honorific Prefix: for titles like Dr. or Sir
    # * +suffix+ - Honorific Suffix: for titles like M.D. or Jr
    # * +org+ - Organization name
    # 
    # ===Address
    # 
    # * +street+ - Street Address
    # * +locality+ - The city or similar
    # * +region+ - The state, county or similar
    # * +postal_code+ - ZIP number
    # * +country+ - The country
    # 
    # ===Contact
    # 
    # * +tel+ - Provide a hash with the phone types and numbers
    # * +url+ - Add a link to a site in the name
    # * +email+ - Add a link to a mailto: address
    def hcard(values, escape = false)

      # support for additional HTML options, e.g. id
      html_options = (values[:html] || {})

      # support for additional classes
      if classes = values[:class]
        classes << " vcard"
      else
        classes = "vcard"
      end

      # Figure out the name. Either FN or combination of family, additional, given.
      unless fn = values[:fn]
        fn = ""
        if prefix = values[:prefix]
          fn += content_tag("span", prefix, {:class => "honorific-prefix"}, escape)
        end
        if org = values[:org]
          fn += " " + content_tag("span", org, {:class => "org"}, escape)
        end
        if given = values[:given]
          fn += " " + content_tag("span", given, {:class => "given-name"}, escape)
        end
        if additional = values[:additional]
          fn += " " + content_tag("span", additional, {:class => 'additional-name'}, escape)
        end
        if family = values[:family]
          fn += " " + content_tag("span", family, {:class => "family-name"}, escape)
        end
        if suffix = values[:suffix]
          fn += ", " + content_tag("span", suffix, {:class => "honorific-suffix"}, escape)
        end
      end


      # Create link or span. Support passing url_for options.
      if url = values[:url]
        container_fn = link_to(fn, url, html_options.update(:class=>"fn n url"), escape)
      else
        container_fn = "\n" + content_tag("span", fn, {:class => "fn n"}, escape) + "\n"
      end

      adr = ""
      if street = values[:street]
        address = true
        adr += content_tag("span", street, {:class => "street-address"}, escape)
      end
      if locality = values[:locality]
        address = true
        adr += " " + content_tag("span", locality, {:class => "locality"}, escape)
      end
      if region = values[:region]
        address = true
        adr += " - " + content_tag("span", region, {:class => "region"}, escape)
      end
      if postal_code = values[:postal_code]
        address = true
        adr += " " + content_tag("span", postal_code, {:class => "postal-code"}, escape)
      end
      if country = values[:country]
        address = true
        adr += " " + content_tag("span", country, {:class => "country"}, escape)
      end
      span_adr = (address == true) ? "\n" + content_tag("span", adr, {:class => "adr"}, escape) + "\n" : ""

      if email = values[:email]
        span_email = "\n" + link_to(email, "mailto:#{email}", {:class => "email"}, escape) + "\n"
      else
        span_email = ""
      end

      if tel = values[:tel]
        tel_values = ""
        tel.sort.reverse.each do |k,v|
          tel_values += content_tag("span", "#{k.capitalize}: ", {:class => "tel-label-#{k} type"}, escape) + content_tag("span", v, {:class => "value"}, escape) + "\n"
        end
        span_tel = "\n" + content_tag("span", tel_values, {:class => "tel"}, escape) + "\n"
      else
        span_tel = ""
      end

      content_tag("span", container_fn + span_adr + span_email + span_tel, html_options.update(:class => classes), escape)
    end


    # Built according to http://www.google.com/support/webmasters/bin/answer.py?answer=146645
    # Currently only intended to be read by machines as the displayed information
    # makes little sense without knowledge of its semantical context (ie. the class
    # attributes).
    # 
    # === Parameters
    # * +values+: a (nested) hash, see below
    # * +escape+: passed to content_tag, defaults to false
    # 
    # === Values
    # The following keys within the +values+ hash are supported:
    # * +html+: additional html attributes to pass to the container content_tag element
    # * +class+: additional css class for the container content_tag element
    # * +fn+: the name of reviewed item
    # * +rating+: hash with keys +average+, +best+ and +worst+, the latter two being
    #             semantically optional. Corresponding values are integers
    # * +count+: Integer. The number of aggregated reviews
    # * +votes+: Integer. People who commented without writing a review. Think Facebook likes.
    # 
    # === Example
    # hreview_aggregate(:fn => "John Doe's Pizza", :count => 3, :rating => { :average => 4, :best => 10 } )
    #
    # => <span class="hreview-aggregate">
    #      <span class="item">
    #        <span class="fn">John Doe's Pizza</span>
    #      </span>
    #      <span class="rating">
    #        <span class="average">4</span>
    #        <span class="best">10</span>
    #      </span>
    #      <span class="count">3</span>
    #    </span>
    #
    def hreview_aggregate(values, escape = false)
      values.symbolize_keys!
      # support for additional HTML options, e.g. id
      html_options = (values[:html] || {})

      # support for additional classes
      if classes = values[:class]
        classes << " hreview-aggregate"
      else
        classes = "hreview-aggregate"
      end

      fn = ""
      if values[:fn]
        # <span class="item">
        #   <span class="fn">Marios Pizza</span>
        # </span>
        fn += content_tag("span", content_tag("span", values[:fn], {:class => "fn"}, escape), {:class => "item"}, escape)
      end

      rating = ""
      if values[:rating]
        # <span class="rating">
        #   <span class="average">9</span>
        #   <span class="best">10</span>
        # </span>
        average = content_tag("span", values[:rating][:average],  {:class => "average"}, escape) if values[:rating][:average]
        best    = content_tag("span", values[:rating][:best],     {:class => "best"},    escape) if values[:rating][:best]
        worst   = content_tag("span", values[:rating][:worst],    {:class => "worst"},   escape) if values[:rating][:worst]
        rating += content_tag("span", [average, best, worst].join("\n"), {:class => "rating"},  escape)
      end

      count = ""
      if values[:count]
        # <span class="count">42</span>
        count += content_tag("span", values[:count], {:class => "count"}, escape)
      end
    
      votes = ""
      if values[:votes]
        # <span class="votes">4711</span>
        votes += content_tag("span", values[:votes], {:class => "votes"}, escape)
      end

      # glue everything together
      content_tag("span", [fn, rating, count, votes].join("\n"), html_options.update(:class => classes), escape)

    end
  end
end