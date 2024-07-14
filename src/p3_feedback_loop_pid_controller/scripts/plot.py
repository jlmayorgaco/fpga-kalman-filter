import sys
import os

# Add the src directory to the PYTHONPATH
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '../..')))

from scripts.utils.VCDSignalsClass import VCDSignalsClass
from scripts.graphs.GraphChartClass import GraphChartClass
from scripts.graphs.GraphBitStreamClass import GraphBitStreamClass
from scripts.boards.ExpResultGraphBoardClass import ExpResultGraphBoardClass


if __name__ == "__main__":


    # ----------------------------------------------------------- #
    # --  VCD File                                            --- #
    # ----------------------------------------------------------- #
    vcd = VCDSignalsClass()
    vcd.setFileVCD('test/main_wave.vcd')
    vcd.setFileJSON('output.json')
    vcd.setModuleName('main_tb')
    vcd.start()
    # ----------------------------------------------------------- #


    # ----------------------------------------------------------- #
    # --  Signals                                             --- #
    # ----------------------------------------------------------- #
    signal_clk = vcd.getSignalByName('clk')
    signal_clk.setLabel('clk')
    signal_clk.setType('bit')

    signal_rst = vcd.getSignalByName('rst')
    signal_rst.setLabel('rst')
    signal_rst.setType('bit')

    signal_u = vcd.getSignalByName('ref')
    signal_u.setLabel('r(t)')
    signal_u.setType('int')

    signal_dist = vcd.getSignalByName('dist')
    signal_dist.setLabel('d(t)')
    signal_dist.setType('int')

    signal_y = vcd.getSignalByName('y')
    signal_y.setLabel('y(t)')
    signal_y.setType('int')


    # ----------------------------------------------------------- #


    # ----------------------------------------------------------- #
    # --  Charts                                              --- #
    # ----------------------------------------------------------- #
    chartGraph = GraphChartClass()
    chartGraph.setLimitX(3000)
    chartGraph.addTitle('Low Pass Noise Filter')
    chartGraph.addLabelX('Time [ns]')
    chartGraph.addLabelY('32 Signed Bits')

    chartGraph.addSignal(signal_y)
    chartGraph.addSignal(signal_u)
    chartGraph.addSignal(signal_dist)


    bitstreamGraph = GraphBitStreamClass()
    bitstreamGraph.addTitle('Timeline Signals')
    bitstreamGraph.addLabelX('Time [ns]')
    bitstreamGraph.addLabelY('')
    bitstreamGraph.addSignal(signal_clk)
    bitstreamGraph.addSignal(signal_rst)
    bitstreamGraph.addSignal(signal_u)
    bitstreamGraph.addSignal(signal_dist)
    bitstreamGraph.addSignal(signal_y)
    # ----------------------------------------------------------- #



    # ----------------------------------------------------------- #
    # --  Board                                               --- #
    # ----------------------------------------------------------- #
    board = ExpResultGraphBoardClass()
    board.setSize((16, 10))
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