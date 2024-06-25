from p0_counter_16bits.scripts.utils.VCDSignalsClass import VCDSignalsClass
from p0_counter_16bits.scripts.graphs.GraphChartClass import GraphChartClass
from p0_counter_16bits.scripts.graphs.GraphBitStreamClass import GraphBitStreamClass
from p0_counter_16bits.scripts.boards.ExpResultGraphBoardClass import ExpResultGraphBoardClass

if __name__ == "__main__":

    vcd = VCDSignalsClass()
    vcd.setFileVCD('p0_counter_16bits_wave.vcd')
    vcd.setFileJSON('output.json')
    vcd.addSignalByName('')
    vcd.addSignalByName('')
    vcd.addSignalByName('')

    signals = vcd.getSignals()
    signal_clk = signals.getByName('')
    signal_rst = signals.getByName('')
    signal_counter = signals.getByName('')

    '''
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