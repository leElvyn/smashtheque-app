module RelatedConcern
  extend ActiveSupport::Concern

  included do

    # ---------------------------------------------------------------------------
    # RELATIONS
    # ---------------------------------------------------------------------------

    belongs_to :related, polymorphic: true, optional: true

    # ---------------------------------------------------------------------------
    # SCOPES
    # ---------------------------------------------------------------------------

    def self.by_related_type(v)
      where(related_type: v)
    end

    def self.by_related_id(v)
      where(related_id: v)
    end

    # ---------------------------------------------------------------------------
    # HELPERS
    # ---------------------------------------------------------------------------

    def related_gid
      self.related&.to_global_id&.to_s
    end

    def related_gid=(gid)
      self.related = GlobalID::Locator.locate gid
    end

    def self.related_autocomplete(term)
      searchable_types = related_types.map(&:to_s)

      {
        results: PgSearch.multisearch(term).where(searchable_type: searchable_types).map do |document|
          model = if document.searchable_type == 'Location'
            # hack for weird bug
            Location.find(document.searchable_id).decorate
          else
            document.searchable.decorate
          end
          {
            id: model.to_global_id.to_s,
            text: model.decorate.autocomplete_name
          }
        end
      }
    end

  end

end
