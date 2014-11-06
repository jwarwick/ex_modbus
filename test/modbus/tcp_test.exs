defmodule TcpTest do
  use ExUnit.Case

  test "wrap packet" do
    assert Modbus.Tcp.wrap_packet(1, 17, <<0x03, 0x006b::size(16), 0x0003::size(16)>>) ==
    <<0x0001::size(16), 0x0000::size(16), 0x0006::size(16), 0x11,
      0x03, 0x006b::size(16), 0x0003::size(16)>>
  end
end
