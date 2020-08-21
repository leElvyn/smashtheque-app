class PlayerDecorator < BaseDecorator

  def characters_links
    model.characters.decorate.map(&:admin_emoji_link)
  end

  def city_link
    model.city&.decorate&.admin_link
  end

  def team_link
    model.team&.decorate&.admin_link
  end

  def icon_class
    :user
  end

  def as_autocomplete_result
    h.content_tag :div, class: :player do
      h.content_tag :div, class: :name do
        name
      end
    end
  end

end
