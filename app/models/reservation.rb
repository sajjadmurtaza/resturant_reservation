require 'csv'
class Reservation < ActiveRecord::Base
  belongs_to :user
  belongs_to :restaurant

  scope :previous_week, lambda { where('created_at > ?', Time.now-7.days) }
  scope :previous_day, lambda { where('created_at > ?', Time.now-1.days) }

  scope :by_restaurant, lambda { |restaurant| where('reservations.restaurant_id = ?', restaurant) }
  scope :by_date, lambda { |start_date,end_date| where('created_at >= ? and created_at <= ?', start_date,end_date) }
  scope :today, -> {where('created_at >= ? and created_at <= ?',Date.today.beginning_of_day,Date.today.end_of_day)}
  scope :active, -> {where(active: true)}
  scope :twelve_hour_old, -> {where('created_at >= ?', Date.today - 12.hours)}
  default_scope -> {order('created_at DESC')}

  # scope :by_restaurant, lambda{ |restaurant| where('restaurants.name = ? AND rest.id = ?', restaurant, self.restaurant.id) }

  # Use in reservation view, return the status(confirmed etc.)
  def status_string
    if active
      'Arriving'
    elsif confirmed
      'Confirmed'
    elsif confirmed == false
      'Cancelled'
    else
      'New'
    end
  end

  def est_seating_time
    # (created_at + wait_time.to_i.minutes).strftime('%Y-%m-%d %H:%M')
    (created_at + wait_time.to_i.minutes).strftime('%m/%d/%Y %I:%M:%S %p UTC')

  end

  def self.search(restaurant_id, date)
   if restaurant_id.present?
     eval("where(restaurant_id: restaurant_id)#{'.by_date(date.to_date.beginning_of_month,date.to_date.end_of_month)' if date.present?}")
   else
     eval("all#{'.by_date(date.to_date.beginning_of_month,date.to_date.end_of_month)' if date.present?}")
   end
  end


  def self.to_csv(est)
    est = est.split(',')
    index = 0
    CSV.generate do |csv|
      csv << ["Status","Party name","Number of people","Est. Seating Time","Date"]
      all.each do |item|
        csv << [item.status_string,item.party_name,item.number_of_people,est[index],item.created_at.strftime("%m/%d/%Y")]
        index += 1
      end
    end
  end

end
