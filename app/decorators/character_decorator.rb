class CharacterDecorator < BaseDecorator

  def admin_link(options = {})
    super(options.merge(label: options[:label] || full_name(max_height: '32px')))
  end

  def admin_emoji_link(options = {})
    label = emoji_image_tag(max_height: '24px')
    admin_link(options.merge(label: label))
  end

  def pretty_name
    model.name.titleize
  end

  def full_name(max_width: nil, max_height: nil)
    [emoji_image_tag(max_width: max_width, max_height: max_height), model.name.titleize].join.html_safe
  end

  def players_path
    admin_players_path(q: {characters_players_character_id_in: [model.id]})
  end

  def players_link
    h.link_to players_count, players_path
  end

  def players_count
    model.players.count
  end

  def emoji_image_url
    "https://cdn.discordapp.com/emojis/#{model.emoji}.png"
  end

  def emoji_image_tag(max_width: nil, max_height: nil)
    return nil if model.emoji.blank?
    h.image_tag_with_max_size emoji_image_url,
                              max_width: max_width,
                              max_height: max_height,
                              class: 'emoji'
  end

  def icon_class
    'user-circle'
  end

  def as_autocomplete_result
    h.content_tag :div, class: 'character' do
      (
        h.content_tag :div, class: :emoji do
          emoji_image_tag
        end
      ) + (
        h.content_tag :div, class: :name do
          pretty_name
        end
      )
    end
  end

end
