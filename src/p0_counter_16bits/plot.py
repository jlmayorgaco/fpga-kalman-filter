from scripts.utils.VCDSignalsClass import VCDSignalsClass
#from scripts.graphs.GraphChartClass import GraphChartClass
#from scripts.graphs.GraphBitStreamClass import GraphBitStreamClass
#from scripts.boards.ExpResultGraphBoardClass import ExpResultGraphBoardClass

if __name__ == "__main__":

    vcd = VCDSignalsClass()
    vcd.setFileVCD('p0_counter_16bits_wave.vcd')
    vcd.setFileJSON('output.json')
    vcd.setModuleName('up_counter_16bit_tb')
    vcd.start()

    '''
    signal_clk = vcd.getSignalByName('clk')
    signal_rst = vcd.getSignalByName('reset')
    signal_counter = vcd.getSignalByName('count[15:0]')

    chartGraph = GraphChartClass()
    chartGraph.addSignal(signal_counter)

    bitstreamGraph = GraphBitStreamClass()
    bitstreamGraph.addBitSignal(signal_clk)
    bitstreamGraph.addBitSignal(signal_rst)
    bitstreamGraph.addHextSignal(signal_counter)

    board = ExpResultGraphBoardClass()
    board.setBitStreamGraph(bitstreamGraph)
    board.setChartGraph(bitstreamGraph)

    board.plot()
    board.save()
'''