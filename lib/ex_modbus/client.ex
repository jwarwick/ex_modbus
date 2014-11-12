defmodule ExModbus.Client do
  @moduledoc """
  ModbusTCP client to manage communication with a device
  """

  use GenServer
  require Logger

  @read_timeout 5000

  # Public Interface

  def start_link(ip = {_a, _b, _c, _d}), do: start_link(%{ip: ip})
  def start_link(args = %{ip: _ip}) do
    GenServer.start_link(__MODULE__, args)
  end

  def read_data(pid, unit_id, start_address, count) do
    GenServer.call(pid, {:read_holding_registers, %{unit_id: unit_id, start_address: start_address, count: count}})
  end

  # GenServer Callbacks

  def init(%{ip: ip}) do
    {:ok, socket} = :gen_tcp.connect(ip, Modbus.Tcp.port, [:binary, {:active, false}])
    {:ok, socket}
  end

  def handle_call({:read_holding_registers, %{unit_id: unit_id, start_address: address, count: count}}, _from, socket) do
    msg = Modbus.Packet.read_holding_registers(address, count) |> Modbus.Tcp.wrap_packet(unit_id)
    Logger.debug "Packet: #{inspect msg}"
    :ok = :gen_tcp.send(socket, msg)
    {:ok, packet} = :gen_tcp.recv(socket, 0, @read_timeout)
    # XXX - handle {:error, closed} and try to reconnect
    Logger.debug "Response: #{inspect packet}"
    unwrapped = Modbus.Tcp.unwrap(packet)
    {:ok, data} = Modbus.Packet.parse_response_packet(unwrapped.packet)
    {:reply, %{unit_id: unwrapped.unit_id, transaction_id: unwrapped.transaction_id, data: data}, socket}
  end
  def handle_call(msg, _from, state) do
    Logger.debug "Unknown handle_cast msg: #{inspect msg}"
    {:reply, "unknown call message", state}
  end

  

end
