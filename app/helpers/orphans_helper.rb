module OrphansHelper
    
    def sponsored_count(orphans)
        num = 0
        orphans.each do |o|
            if o.sponsored?
             num+=1
            end
        end
        return num
    end
    
    def unsponsored_count(orphans)
        num = 0
        orphans.each do |o|
            if o.eligible_for_sponsorship?
             num+=1
            end
        end
        return num
    end
    
end
