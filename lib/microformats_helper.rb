module MicroformatsHelper

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
    div_adr = (address == true) ? "\n" + content_tag("div", adr, :class => "adr") + "\n" : ""

    if email = values[:email]
      div_email = "\n" + link_to(email, "mailto:#{email}", :class => "email") + "\n"
    else
      div_email = ""
    end

    if tel = values[:tel]
      div_tel = "\nTel: " + content_tag("div", tel, :class => "tel") + "\n"
    else
      div_tel = ""
    end

    content_tag("span", container_fn + div_adr + div_email + div_tel, html_options.update(:class => classes))
  end

end