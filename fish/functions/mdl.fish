function mdl
    # 1. Download and embed everything
    # If it's a playlist, it goes in Music/PlaylistName/Title.opus
        # If it's a single video, it goes in Music/Title.opus
    yt-dlp -x --audio-format opus \
                --embed-thumbnail --add-metadata \
                --convert-thumbnails jpg \
                -o "/home/mizx/Music/%(playlist_title|.)s/%(title)s.%(ext)s" \
                $argv[1]
    
    # 2. Cleanup: Move files out of the "." folder if it's a single download
        if test -d "/home/mizx/Music/."
                mv /home/mizx/Music/./* /home/mizx/Music/ 2>/dev/null
                rmdir /home/mizx/Music/. 2>/dev/null
        end
    
        # 3. Final Janitor: Delete leftover image clutter
        find /home/mizx/Music -type f \( -name "*.webp" -o -name "*.jpg" -o -name "*.png" \) -delete
end
