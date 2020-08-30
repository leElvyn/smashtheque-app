ActiveAdmin.register Locations::City do

  decorate_with Locations::CityDecorator

  has_paper_trail

  menu  parent: '<i class="fas fa-fw fa-map-marker-alt"></i>Localisations'.html_safe,
        label: 'Villes'

  # ---------------------------------------------------------------------------
  # INDEX
  # ---------------------------------------------------------------------------

  index do
    selectable_column
    id_column
    column :name do |decorated|
      decorated.full_name
    end
    column :players do |decorated|
      decorated.players_link
    end
    column :created_at do |decorated|
      decorated.created_at_date
    end
    actions
  end

  filter :name

  # ---------------------------------------------------------------------------
  # FORM
  # ---------------------------------------------------------------------------

  form do |f|
    f.inputs do
      f.input :icon
      f.input :name
    end
    f.actions
  end

  permit_params :icon, :name

  # ---------------------------------------------------------------------------
  # SHOW
  # ---------------------------------------------------------------------------

  show do
    attributes_table do
      row :icon
      row :name
      row :players do |decorated|
        decorated.players_link
      end
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end

  action_item :make_country,
              only: :show do
    link_to 'Transformer en pays', [:make_country, :admin, resource], class: 'green'
  end
  member_action :make_country do
    resource.update_attribute :type, 'Locations::Country'
    redirect_to admin_locations_country_path(resource)
  end

end
