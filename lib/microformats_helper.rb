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
  # 
  # ===Address
  # 
  # * +street+ - Street Address
  # * +locality+ - The city or similar
  # * +region+ - The state, county or similar
  # * +postal-code+ - ZIP number
  # * +country+ - The country
  # 
  # ===Contact
  # 
  # * +tel+ - Provide the phone number
  # * +url+ - Add a link to a site in the name
  # * +email+ - Add a link to a mailto: address
  def hcard(values)

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
      if prefix = values[:prefix]
        fn = content_tag("span", prefix, :class => "honorific-prefix")
      end
      fn = "" unless fn
      if org = values[:org]
        fn += " " + content_tag("span", org, :class => "org")
      end
      if given = values[:given]
        fn += " " + content_tag("span", given, :class => "given-name")
      end
      if additional = values[:additional]
        fn += " " + content_tag("span", additional, :class => 'additional-name')
      end
      if family = values[:family]
        fn += " " + content_tag("span", family, :class => "family-name")
      end
      if suffix = values[:suffix]
        fn += ", " + content_tag("span", suffix, :class => "honorific-suffix")
      end
    end

    # Create link or span. Support passing url_for options.
    if url = values[:url]
      container_fn = link_to(fn, url, html_options.update(:class=>"fn n url"))
    else
      container_fn = "\n" + content_tag("span", fn, :class => "fn n") + "\n"
    end

    if street = values[:street]
      address = true
      adr = content_tag("span", street, :class => "street-address")
    end
    adr = "" unless adr
    if locality = values[:locality]
      address = true
      adr += " " + content_tag("span", locality, :class => "locality")
    end
    if region = values[:region]
      address = true
      adr += " - " + content_tag("span", region, :class => "region")
    end
    if postal_code = values[:postal_code]
      address = true
      adr += " " + content_tag("span", postal_code, :class => "postal-code")
    end
    if country = values[:country]
      address = true
      adr += " " + content_tag("span", country, :class => "country")
    end
    span_adr = (address == true) ? "\n" + content_tag("span", adr, :class => "adr") + "\n" : ""

    if email = values[:email]
      span_email = "\n" + link_to(email, "mailto:#{email}", :class => "email") + "\n"
    else
      span_email = ""
    end

    if tel = values[:tel]
      span_tel = "\nTel: " + content_tag("div", tel, :class => "tel") + "\n"
    else
      span_tel = ""
    end

    content_tag("span", container_fn + span_adr + span_email + span_tel, html_options.update(:class => classes))
  end

end