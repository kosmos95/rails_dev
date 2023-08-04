module MultidbHelper

  def run_using_slave(&block)
    #Multidb.use(:slave, &block)
    block.call
  end
  
  def run_using_master(&block)
    #Multidb.use(:master, &block)
    block.call
  end
  
end
  