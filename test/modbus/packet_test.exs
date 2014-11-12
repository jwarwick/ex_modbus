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

  test "exception response" do
    assert {:ok, {:read_holding_registers_exception, :illegal_data_address}} == Modbus.Packet.parse_response_packet(<<131, 2>>)
  end

  test "read holding registers response" do
    assert {:ok, {:read_holding_registers, [1]}} == Modbus.Packet.parse_response_packet(<<3, 2, 0, 1>>)
  end

  test "read multiple holding registers response" do
    assert {:ok, {:read_holding_registers, [2, 13313]}} == 
      Modbus.Packet.parse_response_packet(<<3, 2, 0, 2, 52, 1>>)
  end
end
