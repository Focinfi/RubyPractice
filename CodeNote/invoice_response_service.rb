# generate html and pdf for a invoice
class Payment::InvoiceResponseService
  def initialize(opts)
    invoice = opts[:invoice]
    @account = opts[:account]
    invoice_details = MultiJson.decode invoice.ext_object

    @invoice_number = invoice.ext_id.to_i
    @currency = invoice_details['line_items'].last['currency']
    @total = dallor_of_cents invoice.total
    @invoice_bill_on = date_format invoice_details['line_items'].last['created_at']
    @invoice_items = invoice_details['line_items'].map { |item| filter_invoice_items_data item }
  end

  def to_html
    # TODO: move Cache id to a method
    expires_in = Rails.env.production? ? 5.minutes : 5.seconds
    Rails.cache.fetch("Recurly.Invoice.Customized.HTML.#{@invoice_number}", expires_in: expires_in) do
      html_form_markdown markdown_str
    end
  end

  def to_pdf
    # TODO: remove WickedPdf
    expires_in = Rails.env.production? ? 5.minutes : 5.seconds
    Rails.cache.fetch("Recurly.Invoice.Customized.PDF.#{@invoice_number}", expires_in: expires_in) do
      WickedPdf.new.pdf_from_string(html_form_markdown markdown_str)
    end
  end

  private

  def markdown_str
    invoice_md = Payment::InvoiceMarkdownService.new(@currency)
    invoice_md.bill_on_date = @invoice_bill_on.to_s
    invoice_md.bill_to = @account.billing_info.join('<br/>')
    invoice_md.bill_items = invoice_md.md_table_str_from(@invoice_items)
    invoice_md.bill_total = @total
    invoice_md.to_s
  end

  def html_form_markdown(md)
    Kramdown::Document.new(md).to_html
  end

  def filter_invoice_items_data(invoice_hash)
    {
      date: date_format(invoice_hash['start_date']),
      description: invoice_hash['description'],
      quantity: invoice_hash['quantity'],
      price: dallor_of_cents(invoice_hash['unit_amount_in_cents']),
      subtotal: dallor_of_cents(invoice_hash['total_in_cents'])
    }
  end

  def date_format(data_str)
    return unless data_str
    Date.parse(data_str).strftime('%B %d, %Y')
  end

  def dallor_of_cents(cents)
    cents / 100.0
  end
end
