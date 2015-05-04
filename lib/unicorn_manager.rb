require "fileutils"

module UnicornManager
  class << self
    def command(command, options)
      read_config_file(options)

      case command
      when "start"
        exec("unicorn_rails #{options.to_a.join(' ')}")
      when "usr2", "reload"
        quit_old_pid
        send_signal_to_master("USR2")
        sleep 2
        wait_until_suicide
        quit_old_pid
      when "quit", "stop"
        send_signal_to_master("QUIT")
      when "int", "kill"
        send_signal_to_master("INT")
      when "usr1", "rotatelog"
        send_signal_to_master("USR1")
      when "hup"
        send_signal_to_master("HUP")
      when "ttin", "incr"
        send_signal_to_master("TTIN")
      when "ttou", "decr"
        send_signal_to_master("TTOU")
      else
        puts "unknown command: #{command}"
      end
    end

    def read_config_file(options)
      filename = options["-c"]
      lines = File.readlines(filename)
      line = lines.detect { |li| li =~ /\Apid/ }
      @pid_file = line.split(" ")[1].tr('"', "")
    end

    attr_reader :pid_file

    def old_pid_file
      pid_file + ".oldbin"
    end

    def master_pid
      File.read(pid_file).strip.to_i
    end

    def old_pid
      File.read(old_pid_file).strip.to_i
    end

    def send_signal(signal, pid)
      puts "Sending #{signal} signal to process #{pid} ... "
      Process.kill(signal, pid)
    end

    def send_signal_to_master(signal)
      if send_signal(signal, master_pid)
        puts "unicorn master successfully SIG#{signal}ed"
      else
        puts "cannot send SIG#{signal} signal to unicorn server."
      end
    end

    def quit_old_pid
      retry_cnt = 0
      while File.exist?(old_pid_file) && retry_cnt < 5
        send_signal("QUIT", old_pid)
        retry_cnt += 1
        sleep 2
      end
      if File.exist?(old_pid_file)
        puts "old_pid still exists after 5 retry"
        exit 1
      end
    end

    def wait_until_suicide
      retry_cnt = 0
      while File.exist?(old_pid_file) && retry_cnt < 30
        retry_cnt += 1
        sleep 2
      end
    end
  end
end
