module GetRawDataCommands
  class AddReopeneuCommand
    include HTTParty
    require 'json'

    def execute
      raw_data = CovidRawDatum.find_by(
        data_source: "ReopenEU"
      )

      if raw_data.nil? || raw_data.blank?
        CovidRawDatum.create(data_source: "ReopenEU", raw_json: JSON.parse(get_all_reopenEU_data))
        return
      end

      raw_data.update(raw_json: JSON.parse(get_all_reopenEU_data), updated_at: Time.current)
    end

    private

    def get_all_reopenEU_data
      HTTParty.get('https://reopen.europa.eu/api/covid/v1/eutcdata/data/en/all/all').as_json
    end
  
  end
end
