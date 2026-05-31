function ls --wraps='eza -1lb --classify=always --color=always --icons=always --hyperlink --group-directories-first --header --no-user' --description 'alias ls=eza -1lb --classify=always --color=always --icons=always --hyperlink --group-directories-first --header --no-user'
    eza -1lb --classify=always --color=always --icons=always --hyperlink --group-directories-first --header --no-user $argv
end
