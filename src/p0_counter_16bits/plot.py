from scripts.utils.VCDSignalsClass import VCDSignalsClass
from scripts.graphs.GraphChartClass import GraphChartClass
from scripts.graphs.GraphBitStreamClass import GraphBitStreamClass
from scripts.boards.ExpResultGraphBoardClass import ExpResultGraphBoardClass

if __name__ == "__main__":


    # ----------------------------------------------------------- #
    # --  VCD File                                            --- #
    # ----------------------------------------------------------- #
    vcd = VCDSignalsClass()
    vcd.setFileVCD('p0_counter_16bits_wave.vcd')
    vcd.setFileJSON('output.json')
    vcd.setModuleName('up_counter_16bit_tb')
    vcd.start()
    # ----------------------------------------------------------- #


    # ----------------------------------------------------------- #
    # --  Signals                                             --- #
    # ----------------------------------------------------------- #
    signal_clk = vcd.getSignalByName('clk')
    signal_clk.setLabel('clk')
    signal_clk.setType('bit')

    signal_rst = vcd.getSignalByName('reset')
    signal_rst.setLabel('rst')
    signal_rst.setType('bit')

    signal_counter = vcd.getSignalByName('count[15:0]')
    signal_counter.setLabel('counter')
    signal_counter.setType('int')
    # ----------------------------------------------------------- #


    # ----------------------------------------------------------- #
    # --  Charts                                              --- #
    # ----------------------------------------------------------- #
    chartGraph = GraphChartClass()
    chartGraph.addTitle('Counter 16 Bits')
    chartGraph.addLabelX('Time [ms]')
    chartGraph.addLabelY('Value')
    chartGraph.addSignal(signal_counter)

    bitstreamGraph = GraphBitStreamClass()
    bitstreamGraph.addSignal(signal_clk)
    bitstreamGraph.addSignal(signal_rst)
    # ----------------------------------------------------------- #



    # ----------------------------------------------------------- #
    # --  Board                                               --- #
    # ----------------------------------------------------------- #
    board = ExpResultGraphBoardClass()
    board.setChartGraph(chartGraph)
    board.setBitStreamGraph(bitstreamGraph)
    board.render()

    print('bitstreamGraph')
    print(bitstreamGraph)
    print('0o9')

    # ----------------------------------------------------------- #


    '''




    board.plot()
    board.save()
'''