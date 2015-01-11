if @sponsors.empty?
  'No Sponsors found'
else
  '
  <table>
    <thead>
      <tr>
        <th>
          Osra Num
        </th>
        <th>
          Name
        </th>
        <th>
          Status
        </th>
        <th>
          Start Date
        </th>
        <th>
          Request Fulfilled
        </th>
        <th>
          Sponsor Type
        </th>
        <th>
          Country
        </th>
      </tr>
    </thead>
    <tbody>
    '.tap do |page|
      @sponsors.each do |sponsor|
        page << "
        <tr>
          <td>
            #{link_to sponsor.osra_num, hq_sponsor_path(sponsor)}
          </td>
          <td>
            #{link_to sponsor.name, hq_sponsor_path(sponsor)}
          </td>
          <td>
            #{sponsor.status.name}
          </td>
          <td>
            #{format_full_date sponsor.start_date}
          </td>
          <td>
            #{sponsor.request_fulfilled ? 'Yes' : 'No'}
          </td>
          <td>
            #{sponsor.sponsor_type.name}
          </td>
          <td>
            #{ISO3166::Country.search(sponsor.country)}
          </td>
        </tr>
        "
      end
    end << '
    </tbody>
  </table>
  '
end
