function bye --wraps='shutdown now' --description 'alias bye=shutdown now'
  systemctl suspend $argv
        
end
