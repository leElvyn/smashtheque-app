# == Schema Information
#
# Table name: characters
#
#  id               :bigint           not null, primary key
#  background_color :string
#  background_image :text
#  background_size  :integer
#  emoji            :string
#  icon             :string
#  name             :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class Character < ApplicationRecord

  has_many :characters_players, dependent: :destroy
  has_many :players, through: :characters_players
  has_many :discord_guild_relateds, as: :related, dependent: :nullify
  has_many :discord_guilds, through: :discord_guild_relateds

  validates :name, presence: true, uniqueness: true
  validates :icon, presence: true
  validates :emoji, presence: true, uniqueness: true

  # ---------------------------------------------------------------------------
  # SCOPES
  # ---------------------------------------------------------------------------

  def self.on_abc(letter)
    where("unaccent(name) ILIKE '#{letter}%'")
  end

  def self.by_emoji(emoji)
    where(emoji: emoji)
  end

  def self.without_background
    where(background_color: [nil, ''])
  end

  def self.with_discord_guild
    where(id: DiscordGuildRelated.by_related_type(Character.to_s).select(:related_id))
  end

  # ---------------------------------------------------------------------------
  # global search
  # ---------------------------------------------------------------------------

  include PgSearch::Model
  multisearchable against: %i(name)

  # ---------------------------------------------------------------------------
  # VERSIONS
  # ---------------------------------------------------------------------------

  has_paper_trail unless: Proc.new { ENV['NO_PAPERTRAIL'] }

end
