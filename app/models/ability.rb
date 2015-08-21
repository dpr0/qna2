class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user
    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment]
    can [:update, :edit, :destroy], [Question, Answer, Comment], user: user
    can :index, User
    can :me, User, id: user.id
    can :destroy, Attach, attachable: { user: user }

    can :best, Answer do |answer|
      answer.question.user == user && answer.user != user
    end

    can :cancel, [Question, Answer] do |votable|
      user.voted_for?(votable)
    end

    can [:perfect, :bullshit], [Question, Answer] do |votable|
      votable.user != user && !user.voted_for?(votable)
    end
  end
end
