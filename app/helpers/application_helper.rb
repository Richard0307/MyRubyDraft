require 'lazy_high_charts'
module ApplicationHelper
  def high_chart(div, object)
    LazyHighCharts::HighChart.new(div.to_s) do |chart|
      chart.options[:chart][:defaultSeriesType] = object[:type]
      chart.options[:title][:text] = object[:title]
      chart.options[:xAxis][:categories] = object[:categories]
      chart.options[:yAxis][:title][:text] = object[:y_axis_title]
      chart.series(name: object[:name], data: object[:data])
    end
  end
end
