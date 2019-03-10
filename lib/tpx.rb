class TPX

  def initialize(size, opts = {})
    tix = opts[:tix]

    @size = size
    @jobs = Queue.new

    @pool = Array.new(size) do
      Thread.new do
        Thread.current[:tix] = tix if tix
        catch(:exit) do
          loop do
            begin
              jix, job, args, out = @jobs.pop
              out << [jix, job.call(*args)]
            rescue => e
              out << 'ERROR'
            end
          end
        end
      end
    end
  end

  def schedule(args, &block)
    out = Queue.new
    @jobs << [0, block, args, out]
    (out.pop)[1]
  end

  def schedule_m_build
    Queue.new
  end

  def schedule_m_add(args, &block)
    out = args[0]
    jix = args[1]
    args = args[2]
    @jobs << [jix, block, args, out]
  end

  def schedule_m_read(out, n)
    res = []

    while res.size < n do
      res << (out.pop)
    end

    res.sort{ |x| x[0] }
  end

  def shutdown
    @size.times do
      schedule { throw :exit }
    end

    @pool.map(&:join)
  end
end
