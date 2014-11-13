defmodule ExModbus.Profile.Acuvim do
  @moduledoc """
  Acuvim II Modbus Map
  """

  def property(:temperature) do
    {:read_holding_registers, 0x1037, 1, fn([t]) -> t/10 end}
  end
  def property(:date_time) do
    {:read_holding_registers, 0x1040, 6, fn([y, m, d, h, min, s]) -> {{y, m, d}, {h, min, s}} end}
  end
end
