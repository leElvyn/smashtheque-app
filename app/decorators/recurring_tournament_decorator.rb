class RecurringTournamentDecorator < BaseDecorator

  LEVEL_COLORS = {
    l1_playground: :green,
    l2_anything: :blue,
    l3_glory: :red,
    l4_experts: :black
  }

  def self.level_color(level)
    LEVEL_COLORS[level.to_sym]
  end

  def level_text
    RecurringTournament.human_attribute_name("level.#{model.level}")
  end

  def self.size_name(size)
    size && (size > 128 ? '128+' : size)
  end

  def recurring_type_text
    RecurringTournament.human_attribute_name("recurring_type.#{model.recurring_type}")
  end

  def wday_text
    I18n.t('date.day_names')[model.wday].titlecase
  end

  def full_date
    if model.is_recurring?
      "#{wday_text} à #{starts_at}"
    else
      model.date_description
    end
  end

  def starts_at
    I18n.l(model.starts_at, format: '%Hh%M')
  end

  def date_on_week(monday)
    d = monday.beginning_of_week + ((model.wday + 6) % 7)
    t = model.starts_at
    DateTime.new(d.year, d.month, d.day, t.utc.hour, t.min)
  end

  def as_event(week_start:)
    start = date_on_week(week_start)
    classes = [
      "level-#{model.level}"
    ]
    duration = 3.hours # TODO: improve this
    {
      title: model.name + " (#{model.size})",
      start: start,
      end: start + duration,
      classNames: classes,
      modal_url: modal_recurring_tournament_path(model)
    }
  end

  def tournament_events_count
    model.tournament_events.count
  end

end
