module ApplicationHelper
  def menu_links
    if current_resource
      render :partial => "layouts/#{current_resource.class.to_s.downcase}_links"
    else
      content_for(:login_links)
    end
  end
end
