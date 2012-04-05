require 'oozie_objects'
require 'oozie_jobs'
require 'httparty'

class OozieException < StandardError

end
# so oozie responds in json, only accepts XML, and if there's an error the response is in HTML
class OozieApi
  extend OozieJobs
  
  include HTTParty
  format :plain
  def self.setup(url)
    @@prefix = url
    @@prefix += "/oozie" unless url.include?("/oozie")
    @@prefix += "/v0" unless url.include?("/v0")
  end
  
  # def self.extended(other)
  #   other.send :include, HTTParty
  # end
  
  def self.oozie_get(resource, fmt = :plain)
    response = nil
    begin
      response = get(@@prefix + resource)
    rescue StandardError => ex
      raise OozieException.new(ex)
    end

    case fmt
    when :plain
      response.body

    when :json
      begin
        MultiJson.decode(response.body)  
      rescue StandardError => e
        ex_message = response.headers['oozie-error-code'] ? "#{response.headers['oozie-error-code']}: #{response.headers['oozie-error-message']}": response.body
        error = OozieException.new(ex_message)
        raise error
      end
    end
  end
  
  def self.oozie_post(resource, fmt = :plain, params={})
    response = nil
    begin
      response = post(@@prefix + resource, params)
    rescue StandardError => ex
      raise OozieException.new(ex)
    end

    case fmt
    when :plain
      response.body

    when :json
      begin
        MultiJson.decode(response.body)  
      rescue StandardError => e
        ex_message = response.headers['oozie-error-code'] ? "#{response.headers['oozie-error-code']}: #{response.headers['oozie-error-message']}" : response.body
        error = OozieException.new(ex_message)
        raise error
      end
    end


  end
  
  def self.oozie_put(resource, fmt = :plain, opts={})
    response = nil
    begin
      response = put(@@prefix + resource)
    rescue StandardError => ex
      raise OozieException.new(ex)
    end

    case fmt
    when :plain
      response.body

    when :json
      begin
        MultiJson.decode(response.body)  
      rescue StandardError => e
        ex_message = response.headers['oozie-error-code'] ? "#{response.headers['oozie-error-code']}: #{response.headers['oozie-error-message']}": response.body
        error = OozieException.new(ex_message)
        raise error
      end
    end
  
  end
  
end

# GET
# /oozie/versions
# /oozie/v0/admin/status
# /oozie/v0/admin/os-env
# /oozie/v0/admin/java-sys-properties
# /oozie/v0/admin/configuration
# /oozie/v0/admin/instrumentation
# /oozie/v0/job/job-3?show=info
# /oozie/v0/job/job-3?show=definition
# /oozie/v0/job/job-3?show=log
# /oozie/v0/jobs?filter=user%3Dtucu&offset=1&len=50
# * name: the workflow application name from the workflow definition
# * user: the user that submitted the job
# * group: the group for the job
# * status: the status of the job


# PUT
# /oozie/v0/job/job-3?action=start #=> 'start', 'suspend', 'resume' and 'kill'.
# /oozie/v0/admin/status?safemode=true

# POST
# /oozie/v0/jobs
# Content-Type: application/xml;charset=UTF-8
# .
# <?xml version="1.0" encoding="UTF-8"?>
# <configuration>
#     <property>
#         <name>user.name</name>
#         <value>tucu</value>
#     </property>
#     <property>
#         <name>oozie.wf.application.path</name>
#         <value>hdfs://foo:9000/user/tucu/myapp/</value>
#     </property>
#     ...
# </configuration>

