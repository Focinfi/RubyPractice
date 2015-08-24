# maker a md format str of some specific data
class Payment::InvoiceMarkdownService
  include ActionView::Helpers::NumberHelper

  SECTIONS = [
    :header,
    :bill_from,
    :bill_on_date,
    :bill_to,
    :bill_items,
    :bill_total,
    :footer
  ]

  BILL_INFO_COLUMNS = [
    :date,
    :description,
    :quantity,
    :price,
    :subtotal
  ]

  # may customize sections
  def initialize(currency)
    @currency = currency
    @md_array = []
    set_basic_info
    define_setters SECTIONS
  end

  # param: { section: :bill_from, content: '# Strikingly Inc' }
  def set(info = {})
    section = info[:section]
    return unless SECTIONS.include?(section)
    index = SECTIONS.index section
    @md_array[index] = section_str_of_content(section, info[:content])
  end

  def to_s
    @md_array.join("\r\n\r\n<br/>\r\n\r\n")
  end

  def md_table_str_from(items)
    headers_str = wraper('|', BILL_INFO_COLUMNS.map(&:capitalize).join('|'))
    space_str = '|:-|:-|:-:|:-:|:-:|'
    items_str = items.map { |item| wraper('|', item.values.join('|')) }.join("\n|---\n")
    "\r\n\r\n#{headers_str}\n#{space_str}\n#{items_str}\n{: rules='all'}\n{: border='border'}\n{: cellpadding='5'}"
  end

  private

  def set_basic_info
    # TODO: use a strikingly logo image permalink
    @md_array[SECTIONS.index :header] = 
      "![logo.png](http://7xj8s4.com1.z0.glb.clouddn.com/logo_small.png)"

    @md_array[SECTIONS.index :bill_from] = 
      "## Strikingly Inc \n120 Clipper Dr<br/>Belmont, CA 94002<br/>United States<br/>Email: info@strikingly.com"

    # @md_array[SECTIONS.index :footer] = 'Strikingly Inc all rights reserved'
    @md_array[SECTIONS.index :footer] = "\r\n\r\n|*header*|\n|:-:|\n|world|"
  end

  def define_setters(sections)
    Payment::InvoiceMarkdownService.class_eval do
      sections.each do |section|
        define_method "#{section}=" do |content|
          set(section: section, content: content)
        end
      end
    end
  end

  def section_str_of_content(section, content)
    section_md_str = '### ' + section.to_s.split('_').map(&:capitalize).join(' ') + "\r\n"
    content = filter_number_of content
    section_md_str + content.to_s
  end

  def filter_number_of(content)
    return content unless content.is_a?(Float) || content.is_a?(Float)
    number = number_to_currency(content, locale: @currency.downcase)
    "#{number} #{@currency}"
  end

  def md_with_font_size_style(md_str)    
    "#{md_str}\n{: style='font-size: 25'}"
  end

  def wraper(boundary, str)
    "#{boundary}#{str}#{boundary}"
  end
end
