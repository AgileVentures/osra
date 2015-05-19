module OrphansHelper
    
    def orphans_count(orphans, method)
        num = 0
        orphans.each do |o|
            if o.send(method)
             num+=1
            end
        end
        return num
    end
    
    def orphans_filter( atr , arr )
        new = Array.new
        if atr == "all"
            return arr
        elsif atr == "eligible_for_sponsorship"
            arr.each { |el| new << el if el.eligible_for_sponsorship?}
        elsif atr == "sponsored"
            arr.each { |el| new << el if el.sponsored?}
        end
        return new
    end
end
