class ActiveAdmin::RecurringTournamentDecorator < RecurringTournamentDecorator
  include ActiveAdmin::BaseDecorator

  decorates :recurring_tournament

  def tournament_events_admin_link
    h.link_to(
      tournament_events_count,
      admin_tournament_events_path(
        q: {
          recurring_tournament_id_eq: model.id
        }
      )
    )
  end

  def contacts_admin_links(options = {})
    model.contacts.map do |discord_user|
      discord_user.admin_decorate.admin_link(options)
    end
  end

  def level_status
    arbre do
      status_tag level_text, class: LEVEL_COLORS[model.level.to_sym]
    end
  end

  def discord_guild_admin_link(options = {})
    model.discord_guild&.admin_decorate&.admin_link(options)
  end

  def formatted_registration
    h.content_tag :div, model.registration, class: 'free-text'
  end

end
