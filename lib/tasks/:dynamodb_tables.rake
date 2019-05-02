namespace :dynamodb_tables do
  desc 'simulate dynamodb table creation'
  task my_task1: :environment do
    puts "Creating activities table in #{Rails.env}\n"
    create_activity_table
    puts "Completed task\n"
  end


# docker-compose run backend rake dynamodb_tables:my_task1

  def create_activity_table
    params = {
        table_name: 'activities', # required
        key_schema: [ # required
            {
                attribute_name: 'actor', # required User:1
                key_type: 'HASH', # required, accepts HASH, RANGE
            },
            {
                attribute_name: 'created_at', # timestamp
                key_type: 'RANGE'
            }
        ],
        attribute_definitions: [ # required
            {
                attribute_name: 'actor', # required
                attribute_type: 'S', # required, accepts S, N, B
            },
            {
                attribute_name: 'created_at', # Timestamp
                attribute_type: 'N', # required, accepts S, N, B
            }
        ],

        provisioned_throughput: { # required
                                  read_capacity_units: 5, # required
                                  write_capacity_units: 5, # required
        }
    }

    begin
      DynamodbClient.initialize!
      result = DynamodbClient.client.create_table(params)
      puts 'Created table: activities\n Status: ' + result.table_description.table_status
    rescue Aws::DynamoDB::Errors::ServiceError => error
      puts 'Unable to create table: activities\n'
      puts "#{error.message}"
    end
  end
end