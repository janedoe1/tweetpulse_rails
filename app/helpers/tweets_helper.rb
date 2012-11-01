module TweetsHelper

  def sentiment_icon(tweet)
    case tweet.sentiment.label
    when "pos"
      icon = "<i class='icon-plus'></i>"
    when "neg"
      icon = "<i class='icon-minus'></i>"
    else
      icon = "<i class='icon-asterisk'></i>"
    end
    raw(icon)
  end

end
