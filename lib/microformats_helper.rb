# Microformats Helper is a plugin for generating content-rich tags in HTML files, following Microformats standards. For more information about Microformats, check its website (http://microformats.org).
# 
# Currently only the hCard microformat is available.
# 
# Author:: Ricardo Shiota Yasuda
# Copyright:: Copyright (c) 2008 Ricardo Shiota Yasuda
# License:: MIT License (http://www.opensource.org/licenses/mit-license.php)
#


module MicroformatsHelper

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

    fn = values[:fn] || ""
    
    # glue everything together
    content_tag("span", fn, html_options.update(:class => classes), escape)

  end

end