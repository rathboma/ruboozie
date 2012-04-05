require 'builder'
module OozieJobs
  
  def workflows(params={})
    # TODO: checking for filter/user, offset, len
    resource = "/jobs?jobtype=wf"
    results = oozie_get(resource, :json)
    results['workflows'] ||= []
    results['workflows'].map{|wf| OozieJob.new(wf)}
  end

  def coordinators(params={})
    # TODO: checking for filter/user, offset, len
    
    resource = "/jobs?jobtype=coord"
    results = oozie_get(resource, :json)
    results['coordinatorjobs'] ||= []
    results['coordinatorjobs'].map{|wf| OozieJob.new(wf)}
  end
  
  def log(job_id)
    
    resource = "/job/#{job_id}?show=log"
    oozie_get(resource)
  end
  
  def definition(job_id)
    
    resource = "/job/#{job_id}?show=definition"
    oozie_get(resource)
  end
  
  def info(job_id)
    
    resource = "/job/#{job_id}?show=info"
    OozieJob.new oozie_get(resource, :json)
  end
  
  # submit a job given the properties, params optionsl
  # properties is a hash of the form {name => value}
  # param example: {:action => :start} [starts the job on submission]
  def submit_job(properties, params = {})
    
    body = properties_hash_to_conf_xml(properties)
    
    start_now = params[:start_now]
    proper_params = params.map{|k,v| "#{k}=#{v}"}.join("&")
    resource = "/jobs?#{proper_params}"
    
    response = oozie_post(resource, :json, :body => body, :headers => {"Content-Type" => "application/xml"})
    id = response['id']
    info(id)
  end

  def start_job(job_id)
    resource = "/job/#{job_id}?action=start"
    oozie_put(resource)
  end
  
  def suspend_job(job_id)
    resource = "/job/#{job_id}?action=suspend"
    oozie_put(resource)
  end
  
  def resume_job(job_id)
    resource = "/job/#{job_id}?action=resume"
    oozie_put(resource)
  end
  
  def kill_job(job_id)
    resource = "/job/#{job_id}?action=kill"
    oozie_put(resource)
  end
  
  def properties_hash_to_conf_xml(properties_hash)
    conf_xml = ConfMaker.new(properties_hash).conf
    return conf_xml
  end
  
  def conf_xml_to_properties_hash(conf_xml)
    doc = REXML::Document.new(conf_xml)

    properties = {}
    doc.elements.each("//property") do |property|
      name = property.elements["name"].text
      value = property.elements["value"].text
      properties[name] = value
    end
    
    return properties
  end

  class ConfMaker

    attr_reader :conf

    def initialize(params)
      @conf = ""
      @xb = Builder::XmlMarkup.new(:target => @conf, :indent => 2)
      @xb.configuration do
        params.each do |name, value|
          name = name.to_s unless name.is_a? String
          value = value.to_s unless value.is_a? String
          @xb.property do
            @xb.name(name)
            @xb.value(value)
          end
        end
      end
      return @conf
    end

  end

end



# /oozie/v0/job/job-3?show=info
# /oozie/v0/job/job-3?show=definition
# /oozie/v0/job/job-3?show=log
# /oozie/v0/jobs?filter=user%3Dtucu&offset=1&len=50

# PUT
# /oozie/v0/job/job-3?action=start #=> 'start', 'suspend', 'resume' and 'kill'.
# /oozie/v0/admin/status?safemode=true