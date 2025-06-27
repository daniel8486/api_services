class DropTempTableJob < ApplicationJob
  queue_as :drop_temp_tables

  def perform(full_table_name)
    ActiveRecord::Base.connection.drop_table(full_table_name, if_exists: true)
  end
end
