require 'lazy_high_charts'
class StaffController < ApplicationController
  def index
    # Only allow staff to access this action
    redirect_to pages_home_path unless current_user.is_staff?
  end
  def statistics
    # 获取选中的年份，如果没有选择则默认为当前年份
    year = params[:year] || Time.current.year

    # 查询数据，此处只是示例，需要根据实际情况修改
    data = [
      { month: "January", students_withdrawing: 10 },
      { month: "February", students_withdrawing: 5 },
      { month: "March", students_withdrawing: 8 },
      { month: "April", students_withdrawing: 3 },
      { month: "May", students_withdrawing: 12 },
      { month: "June", students_withdrawing: 6 },
      { month: "July", students_withdrawing: 9 },
      { month: "August", students_withdrawing: 7 },
      { month: "September", students_withdrawing: 4 },
      { month: "October", students_withdrawing: 11 },
      { month: "November", students_withdrawing: 2 },
      { month: "December", students_withdrawing: 13 }
    ]

    # 绘制柱状图
    @chart = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: "Students Withdrawing Statistics in #{year}")
      f.xAxis(categories: data.map { |d| d[:month] })
      f.series(name: 'Number of Students Withdrawing', data: data.map { |d| d[:students_withdrawing] })
      f.chart(type: 'column')
    end
  end
end
