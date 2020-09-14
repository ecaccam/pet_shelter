module QueryHelper
	extend ActiveSupport::Concern

	# MODEL HELPERS for simple repetitive MySQL queries
	class_methods do
		def db_datetime
			return Time.now.utc.strftime("%Y-%m-%d %H:%M:%S")
		end

		def query_record(sql_statement)
			ActiveRecord::Base.connection.select_one(
				ActiveRecord::Base.send(:sanitize_sql_array, sql_statement)
			)
		end

		def query_records(sql_statement)
			ActiveRecord::Base.connection.exec_query(
				ActiveRecord::Base.send(:sanitize_sql_array, sql_statement)
			).to_hash
		end

		def insert_record(sql_statement)
			ActiveRecord::Base.connection.insert(
				ActiveRecord::Base.send(:sanitize_sql_array, sql_statement)
			)
		end

		def update_record(sql_statement)
			ActiveRecord::Base.connection.update(
				ActiveRecord::Base.send(:sanitize_sql_array, sql_statement)
			)
		end

		def delete_record(sql_statement)
			ActiveRecord::Base.connection.delete(
				ActiveRecord::Base.send(:sanitize_sql_array, sql_statement)
			)
		end
	end
end