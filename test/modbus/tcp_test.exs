defmodule TcpTest do
  use ExUnit.Case

  test "wrap packet" do
    assert Modbus.Tcp.wrap_packet(<<0x03, 0x006b::size(16), 0x0003::size(16)>>, 17, 1) ==
    <<0x0001::size(16), 0x0000::size(16), 0x0006::size(16), 0x11,
      0x03, 0x006b::size(16), 0x0003::size(16)>>
  end

  test "identity unwrap packet" do
    packet = <<0x03, 0x006b::size(16), 0x0003::size(16)>>
    wrapped = Modbus.Tcp.wrap_packet(packet, 17, 1)
    unwrapped = Modbus.Tcp.unwrap_packet(wrapped)
    assert unwrapped.unit_id == 17
    assert unwrapped.transaction_id == 1
    assert unwrapped.packet == packet
  end

  test "unwrap packet" do
    wrapped = <<0x0006::size(16), 0x0000::size(16), 0x0006::size(16), 0x20,
      0x03, 0x006b::size(16), 0x0003::size(16)>>
    unwrapped = Modbus.Tcp.unwrap_packet(wrapped)
    assert unwrapped.unit_id == 32
    assert unwrapped.transaction_id == 6
    assert unwrapped.packet == <<0x03, 0x006b::size(16), 0x0003::size(16)>>
  end
end
