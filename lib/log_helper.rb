module LogHelper
  def log(*messages, level: :info, separator: ', ')
    buffer = "[#{self.class.name}##{calling_method}]"
    buffer = "" if buffer == '[Object#block]'
    buffer << "(#{maybe_id})" if maybe_id
    buffer << " "
    buffer << messages.join(separator)
    Rails.logger.send(level, buffer)
  end
  
  def log_exception(e)
    log "#{e.class}: #{e.message}", level: :error
  end

  def calling_method
    return :block if caller[1].match(/block \(\d+ levels\)/)

    caller[1].match(/`(.*?)'/)[1]
  end

  def maybe_id
    self.respond_to?(:id) ? self.id : nil
  end
end
