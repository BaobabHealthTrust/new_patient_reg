class CouchSQL
  include SuckerPunch::Job
  workers 1

  def perform()
   `bundle exec rake edrs:couch_mysql`
   CouchSQL.perform_in(30)
  end rescue CouchSQL.perform_in(30)
end

