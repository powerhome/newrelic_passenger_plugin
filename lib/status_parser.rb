class Status
  require 'date'

  def initialize(output)
    status_command = output.match(/<.+/m).to_s
    doc = Nokogiri::XML(status_command,nil,'iso8859-1')

    @status_result = [
      doc.xpath('//info/max').text.to_i,
      doc.xpath('//info/supergroups/supergroup/group/capacity_used').text.to_i,
      doc.xpath('//info/supergroups/supergroup/group/get_wait_list_size').text.to_i,
      parse_sessions(doc),
      parse_cpu(doc),
      parse_app_memory(doc),
      parse_last_used(doc),
      doc.xpath('//info/supergroups/supergroup/group/enabled_process_count').text.to_i,
      doc.xpath('//info/supergroups/supergroup/group/disabling_process_count').text.to_i,
      doc.xpath('//info/supergroups/supergroup/group/disabled_process_count').text.to_i,
      doc.xpath('//info/supergroups/supergroup/group/disable_wait_list_size').text.to_i,
      doc.xpath('//info/supergroups/supergroup/group/processes_being_spawned').text.to_i
    ]
  end

  def max_processes_count
    @status_result[0]
  end

  def currenct_process_count
    @status_result[1]
  end

  def waiting_request_count
    @status_result[2]
  end

  def sessions
    @status_result[3]
  end

  def cpu
    @status_result[4]
  end

  def process_memory
    @status_result[5]
  end

  def last_used_time
    @status_result[6]
  end
  
  def enabled_process_count
    @status_result[7]
  end
  
  def disabling_process_count
    @status_result[8]
  end
  
  def disabled_process_count
    @status_result[9]
  end
  
  def disable_wait_process_count
    @status_result[10]
  end
  
  def being_spawned_process_count
    @status_result[11]
  end

  private

  def name_clean(app_name)
    if app_name.length > 45
      first_half = app_name.match('.+:').to_s
      second_half = app_name.split('/')[-1].to_s
      cleaned_name = first_half + ' ' + second_half
    else
      cleaned_name = app_name
    end
    cleaned_name
  end

  def parse_sessions(doc)
    sessions_total = 0
    doc.xpath('//process/sessions').each do |x|
      sessions_total += x.text.to_i
    end
    sessions_total
  end

  def parse_cpu(doc)
    cpu_total = 0
    doc.xpath('//process/cpu').each do |x|
      cpu_total += x.text.to_f
    end
    cpu_total
  end

  def parse_app_memory(doc)
    processes = Hash.new(0)
    doc.xpath('//process').each do |x|
      processes[name_clean(x.xpath('./command').text)] += x.xpath('./real_memory').text.to_i
    end
    processes
  end

  def parse_last_used(doc)
    processes = Hash.new(0)
    doc.xpath('//process').each_with_index do |x, index|
      unix_stamp = (x.xpath('./last_used').text.to_i / 1000000)
      elapsed = Time.now.to_i - unix_stamp
      processes[(index + 1).to_s] = elapsed
    end
    processes
  end

end
