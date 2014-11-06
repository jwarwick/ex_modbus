defmodule PacketTest do
  use ExUnit.Case

  test "read coils" do
    assert Modbus.Packet.read_coils(20, 37) == <<0x01, 0x0013::size(16), 0x0025::size(16)>>
  end

  test "read discrete inputs" do
    assert Modbus.Packet.read_discrete_inputs(197, 22) == <<0x02, 0x00c4::size(16), 0x0016::size(16)>>
  end

  test "read holding registers" do
    assert Modbus.Packet.read_holding_registers(108, 3) == <<0x03, 0x006b::size(16), 0x0003::size(16)>>
  end

  test "read input registers" do
    assert Modbus.Packet.read_input_registers(9, 1) == <<0x04, 0x0008::size(16), 0x0001::size(16)>>
  end
end
