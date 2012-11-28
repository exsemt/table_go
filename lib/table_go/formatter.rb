module TableGo
  class Formatter
    extend ActionView::Helpers::NumberHelper

    class MissingFormatterError < StandardError; end

    class_attribute :formatters
    self.formatters = {}



    formatters.store(:date,
      lambda do |value, record, column|
        I18n.l(value, :format => (column.as_options[:format] || :default))
      end
    )

    formatters.store(:datetime,
      lambda do |value, record, column|
        I18n.l(Time.parse(value.to_s).localtime, :format => (column.as_options[:format] || :default))
      end
    )

    formatters.store(:boolean,
      lambda do |value, record, column|
        if value == true
          'true'
        elsif value == false
          'false'
        end
      end
    )

    formatters.store(:percent,
      lambda do |value, record, column|
        sprintf("%01.2f%", value)
      end
    )

    formatters.store(:euro_currency,
      lambda do |value, record, column|
        sprintf("€ %01.2f", value).gsub('.', ',')
      end
    )

    formatters.store(:currency,
      lambda do |value, record, column|
        number_to_currency(value)
      end
    )




    def self.apply(formatter, record, column, value)
      formatter_proc =
        case formatter
        when Symbol;  formatters[formatter.to_sym]
        when Proc;    formatter
        end

      raise MissingFormatterError.new('formatter "%s" not found' % formatter) if formatter_proc.blank?
      formatter_proc.call(value, record, column).to_s.html_safe
    end


  end
end


    #   when Time
    #     I18n.l(value.localtime, :format => :compact)
