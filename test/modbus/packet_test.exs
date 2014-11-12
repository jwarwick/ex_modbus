defmodule PacketTest do
  use ExUnit.Case

  test "read coils" do
    assert Modbus.Packet.read_coils(19, 37) == <<0x01, 0x0013::size(16), 0x0025::size(16)>>
  end

  test "read discrete inputs" do
    assert Modbus.Packet.read_discrete_inputs(196, 22) == <<0x02, 0x00c4::size(16), 0x0016::size(16)>>
  end

  test "read holding registers" do
    assert Modbus.Packet.read_holding_registers(107, 3) == <<0x03, 0x006b::size(16), 0x0003::size(16)>>
  end

  test "read input registers" do
    assert Modbus.Packet.read_input_registers(8, 1) == <<0x04, 0x0008::size(16), 0x0001::size(16)>>
  end

  # XXX - Output from meter - add to tests

  # 17:38:54.528 [debug] Packet: <<0, 1, 0, 0, 0, 6, 1, 3, 16, 0, 0, 1>>

  # 17:38:54.546 [debug] Response: <<0, 1, 0, 0, 0, 5, 1, 3, 2, 0, 0>>
  # "data"
  # iex(3)> ExModbus.Client.read_data(pid, 0x1002, 1)

  # 17:39:25.088 [debug] Packet: <<0, 1, 0, 0, 0, 6, 1, 3, 16, 1, 0, 1>>

  # 17:39:25.103 [debug] Response: <<0, 1, 0, 0, 0, 5, 1, 3, 2, 0, 1>>
  # "data"
  # iex(4)> ExModbus.Client.read_data(pid, 0x1002, 2)

  # 17:39:31.897 [debug] Packet: <<0, 1, 0, 0, 0, 6, 1, 3, 16, 1, 0, 2>>

  # 17:39:31.916 [debug] Response: <<0, 1, 0, 0, 0, 7, 1, 3, 4, 0, 1, 75, 0>>
  # "data"
  # iex(5)> ExModbus.Client.read_data(pid, 0x1001, 2)

  # 17:39:44.857 [debug] Packet: <<0, 1, 0, 0, 0, 6, 1, 3, 16, 0, 0, 2>>

  # 17:39:44.870 [debug] Response: <<0, 1, 0, 0, 0, 7, 1, 3, 4, 0, 0, 0, 1>>
  # iex(12)> ExModbus.Client.read_data(pid, 0x4000, 2)

  # 17:35:57.723 [debug] Packet: <<0, 1, 0, 0, 0, 6, 1, 3, 63, 255, 0, 2>>

  # 17:35:57.742 [debug] Response: <<0, 1, 0, 0, 0, 3, 1, 131, 2>>
  # "data"
  # iex(13)> ExModbus.Client.read_data(pid, 0x4000, 2)

  # 17:36:03.363 [debug] Packet: <<0, 1, 0, 0, 0, 6, 1, 3, 63, 255, 0, 2>>

  # 17:36:03.376 [debug] Response: <<0, 1, 0, 0, 0, 3, 1, 131, 2>>
  # "data"
  # iex(14)> ExModbus.Client.read_data(pid, 0x4000, 2)

  # 17:36:06.907 [debug] Packet: <<0, 1, 0, 0, 0, 6, 1, 3, 63, 255, 0, 2>>

  # 17:36:06.968 [debug] Response: <<0, 1, 0, 0, 0, 3, 1, 131, 2>>
  # "data"
  # iex(15)> ExModbus.Client.read_data(pid, 0x4000, 4)

  # 17:36:09.700 [debug] Packet: <<0, 1, 0, 0, 0, 6, 1, 3, 63, 255, 0, 4>>

  # 17:36:09.711 [debug] Response: <<0, 1, 0, 0, 0, 3, 1, 131, 2>>
  # "data"
  # iex(16)> ExModbus.Client.read_data(pid, 0x1000, 4)

  # 17:36:33.844 [debug] Packet: <<0, 1, 0, 0, 0, 6, 1, 3, 15, 255, 0, 4>>

  # 17:36:33.858 [debug] Response: <<0, 1, 0, 0, 0, 11, 1, 3, 8, 0, 3, 0, 0, 0, 1, 75, 0>>
  # "data"
  # iex(17)> ExModbus.Client.read_data(pid, 0x1000, 4)

  # 17:36:38.140 [debug] Packet: <<0, 1, 0, 0, 0, 6, 1, 3, 15, 255, 0, 4>>

  # 17:36:38.157 [debug] Response: <<0, 1, 0, 0, 0, 11, 1, 3, 8, 0, 3, 0, 0, 0, 1, 75, 0>>
end
