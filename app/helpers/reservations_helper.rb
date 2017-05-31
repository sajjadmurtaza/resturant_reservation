module ReservationsHelper

  def month_array
    start = Date.today.beginning_of_year
    end_date = Date.today.end_of_year
    list = []
    while(start < end_date)
      list << start.strftime('%B')
      start += 1.month
    end
    list
  end

   def year_array
    start = '1/1/2015'.to_date
    end_date = start + 20.years
    list = []
    while(start < end_date)
      list << start.strftime('%Y')
      start += 1.year
    end
    list
  end
end
