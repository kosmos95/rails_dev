module HanurisHelper

  def country_starting_with(char, lang = 'EN')
    ISO3166::Country.translations(lang).filter { |x, y| y =~ %r{^#{char}}i }
  end
  
  def lang_start_chars(lang = 'EN')
    case lang 
    when 'KO'
      '가나다라마바사아자차카타파하'.split('')
    else 
      ('A'..'Z').map { |x| x.upcase }
    end
  end
  
  def next_kor_char_of(ch)
    chars = '가나다라마바사아자차카타파하'.split('')
    idx = chars.index(ch)
    if !idx.nil? 
      next_idx = [idx + 1, chars.length - 1].min
      chars[next_idx]
    else
      chars.filter { |x| x > ch }.first
    end
  end
    
end
