class ActiveAdmin::RecurringTournamentDecorator < RecurringTournamentDecorator
  include ActiveAdmin::BaseDecorator

  decorates :recurring_tournament

  def contacts_admin_links(options = {})
    model.contacts.map do |discord_user|
      discord_user.admin_decorate.admin_link(options)
    end
  end

  LEVEL_COLORS = {
    l1_playground: :green,
    l2_anything: :blue,
    l3_glory: :red,
    l4_experts: :black
  }

  def level_status
    arbre do
      status_tag level_text, class: LEVEL_COLORS[model.level.to_sym]
    end
  end

end