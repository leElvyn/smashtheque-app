class CharactersController < PublicController

  has_scope :by_emoji

  def index
    @characters = apply_scopes(Character.order("lower(name)")).all
  end

end
