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

  def read_coils(pid, unit_id, start_address, count) do
    GenServer.call(pid, {:read_coils, %{unit_id: unit_id, start_address: start_address, count: count}})
  end

  @doc """
  Write a single coil at address. Possible states are `:on` and `:off`.
  """
  def write_single_coil(pid, unit_id, address, state) do
    GenServer.call(pid, {:write_single_coil, %{unit_id: unit_id, start_address: address, state: state}})
  end

  def generic_call(pid, unit_id, {call, address, count, transform}) do
    %{data: {_type, data}} = GenServer.call(pid, {call, %{unit_id: unit_id, start_address: address, count: count}})
    transform.(data)
  end


  # GenServer Callbacks

  def init(%{ip: ip}) do
    {:ok, socket} = :gen_tcp.connect(ip, Modbus.Tcp.port, [:binary, {:active, false}])
    {:ok, socket}
  end

  def handle_call({:read_coils, %{unit_id: unit_id, start_address: address, count: count}}, _from, socket) do
    # limits the number of coils returned to the number `count` from the request
    limit_to_count = fn msg ->
                        {:read_coils, lst} = msg.data
                        {_, elems} = Enum.split(lst, -count)
                        %{msg | data: {:read_coils, elems}}
    end
    response = Modbus.Packet.read_coils(address, count)
               |> Modbus.Tcp.wrap_packet(unit_id)
               |> send_and_rcv_packet(socket)
               |> limit_to_count.()

    {:reply, response, socket}
  end

  def handle_call({:read_holding_registers, %{unit_id: unit_id, start_address: address, count: count}}, _from, socket) do
    response = Modbus.Packet.read_holding_registers(address, count)
               |> Modbus.Tcp.wrap_packet(unit_id)
               |> send_and_rcv_packet(socket)
    {:reply, response, socket}
  end

  def handle_call({:write_single_coil, %{unit_id: unit_id, start_address: address, state: state}}, _from, socket) do
    response = Modbus.Packet.write_single_coil(address, state)
               |> Modbus.Tcp.wrap_packet(unit_id)
               |> send_and_rcv_packet(socket)
    {:reply, response, socket}
  end

  def handle_call(msg, _from, state) do
    Logger.debug "Unknown handle_cast msg: #{inspect msg}"
    {:reply, "unknown call message", state}
  end

  defp send_and_rcv_packet(msg, socket) do
    Logger.debug "Packet: #{inspect msg}"
    :ok = :gen_tcp.send(socket, msg)
    {:ok, packet} = :gen_tcp.recv(socket, 0, @read_timeout)
    # XXX - handle {:error, closed} and try to reconnect
    Logger.debug "Response: #{inspect packet}"
    unwrapped = Modbus.Tcp.unwrap_packet(packet)
    {:ok, data} = Modbus.Packet.parse_response_packet(unwrapped.packet)
    %{unit_id: unwrapped.unit_id, transaction_id: unwrapped.transaction_id, data: data}
  end

end
