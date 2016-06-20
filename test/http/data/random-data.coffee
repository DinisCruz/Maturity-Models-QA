Http_API  = require '../../../src/_Test_APIs/Http-API'

describe 'http | data | team-random', ->

  http_API = null

  before ()->
    http_API = new Http_API()


  it 'check team-random.json data is random', (done)->

    http_API.GET_Json '/api/v1/team/demo/get/team-random', (json)->
      json.metadata.team.assert_Is 'Team Random'

      matches = { Yes: 0, No : 0, NA: 0, Maybe: 0}

      check_Domain = (domain, size)->
        for activity, value of json.activities[domain]
          matches._keys().assert_Contains value
          matches[value]++

        json.activities[domain]._keys().size().assert_Is size

      check_Domain 'Governance'  , 20
      check_Domain 'Intelligence', 15
      check_Domain 'SSDL'        , 15
      check_Domain 'Deployment'  , 19

      for key,value of matches            # check that we have at least one
        value.assert_Is_Bigger_Than 0

      done()

  it 'check team-random.json data is different for two separate requests', (done)->
    http_API.GET_Json '/api/v1/team/demo/get/team-random', (json_1)->
      http_API.GET_Json '/api/v1/team/demo/get/team-random', (json_2)->
        json_1.metadata.team.assert_Is 'Team Random'
        json_1.assert_Is_Not json_2
        done()