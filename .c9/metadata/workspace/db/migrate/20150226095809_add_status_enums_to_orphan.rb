{"filter":false,"title":"20150226095809_add_status_enums_to_orphan.rb","tooltip":"/db/migrate/20150226095809_add_status_enums_to_orphan.rb","undoManager":{"mark":13,"position":13,"stack":[[{"group":"doc","deltas":[{"start":{"row":25,"column":6},"end":{"row":26,"column":68},"action":"remove","lines":["status_code = orphan.orphan_sponsorship_status.code","      orphan.update_column(:sponsorship_status, ( status_code - 1 ))"]},{"start":{"row":25,"column":6},"end":{"row":27,"column":81},"action":"insert","lines":["+      orphan_sponsorship_status = orphan_sponsorship_statuses.select {|oss| oss[\"id\"] == orphan.orphan_sponsorship_status_id.to_s}.first","+      sponsorship_status_code = orphan_sponsorship_status[\"code\"].to_i","+      orphan.update_column(:sponsorship_status, ( sponsorship_status_code - 1 ))"]}]}],[{"group":"doc","deltas":[{"start":{"row":25,"column":6},"end":{"row":25,"column":13},"action":"remove","lines":["+      "]}]}],[{"group":"doc","deltas":[{"start":{"row":25,"column":6},"end":{"row":25,"column":7},"action":"insert","lines":[" "]}]}],[{"group":"doc","deltas":[{"start":{"row":26,"column":0},"end":{"row":26,"column":1},"action":"remove","lines":["+"]}]}],[{"group":"doc","deltas":[{"start":{"row":26,"column":0},"end":{"row":26,"column":2},"action":"insert","lines":["  "]}]}],[{"group":"doc","deltas":[{"start":{"row":27,"column":0},"end":{"row":27,"column":1},"action":"remove","lines":["+"]}]}],[{"group":"doc","deltas":[{"start":{"row":27,"column":0},"end":{"row":27,"column":2},"action":"insert","lines":["  "]}]}],[{"group":"doc","deltas":[{"start":{"row":26,"column":6},"end":{"row":26,"column":8},"action":"remove","lines":["  "]}]}],[{"group":"doc","deltas":[{"start":{"row":26,"column":4},"end":{"row":26,"column":6},"action":"remove","lines":["  "]}]}],[{"group":"doc","deltas":[{"start":{"row":26,"column":4},"end":{"row":26,"column":6},"action":"insert","lines":["  "]}]}],[{"group":"doc","deltas":[{"start":{"row":25,"column":6},"end":{"row":25,"column":7},"action":"remove","lines":[" "]}]}],[{"group":"doc","deltas":[{"start":{"row":25,"column":6},"end":{"row":25,"column":8},"action":"insert","lines":["  "]}]}],[{"group":"doc","deltas":[{"start":{"row":25,"column":6},"end":{"row":25,"column":8},"action":"remove","lines":["  "]}]}],[{"group":"doc","deltas":[{"start":{"row":27,"column":6},"end":{"row":27,"column":8},"action":"remove","lines":["  "]}]}]]},"ace":{"folds":[],"scrolltop":90,"scrollleft":0,"selection":{"start":{"row":27,"column":6},"end":{"row":27,"column":6},"isBackwards":false},"options":{"guessTabSize":true,"useWrapMode":false,"wrapToView":true},"firstLineState":{"row":5,"state":"start","mode":"ace/mode/ruby"}},"timestamp":1430224669523,"hash":"ecb901a592a768e2e76660cc25ac49c03ba4f063"}